class Import < ActiveRecord::Base
  # Opens an xml file at path and returns it's Nokogiri::XML object
  # String(path) -> Nokogiri::XML
  def self.path(path = "lib/assets/MaraDetail.dnd4e")
    f = File.open(path)
    xml = Nokogiri::XML(f)
    f.close
    xml
  end


  def self.import(path = "lib/assets/maraDetail.dnd4e", user_id = 1)
    xml = Import.path(path)
    c = go(xml)
    c.user_id = user_id
    c.save
  end

  def self.import_file(file)
    xml = Nokogiri::XML(file)
    go(xml)
  end

  def self.go(xml)
    # Import char and save it so we can reference powers and skills to it
    c = Import.import_character(xml)
    c.save

    # import skills (value, trained or not, attribute)
    skills(xml).each do |s|
      c.skills.create(s)
    end

    # Import feats and racial/class features
    feats(xml).each do |f|
      c.feats.create(f)
    end

    # import powers, weapons those powers can be used with etc and save them
    pwrs = Import.import_powers(c, xml)
    pwrs.each do |p|
      p.first.save
    end

    rtls = Import.import_rituals(c, xml)
    rtls.each do |r|
      r.first.save
    end
    c
  end

  def self.import_character(xml)
    char = Character.new

    stats = self.misc_stats(xml)
    stats = stats.merge(self.ability_scores(xml))
    stats = stats.merge(self.details(xml))
    stats = stats.merge(self.additional_details(xml))

    stats.each do |k, v|
      char.send((k + "=").to_sym, v)
    end
    char
  end

  def self.import_power_atributes(power, attr)
    v = attr.last
    k = attr.first
    v1 = (Array === v)? v.first : v
    if k == "weapon"
      return nil if String === v
      wpn = v.select{|k, v| v.present? and WEAPON_STATS.include? k.to_s}
      power.power_weapons.new(wpn)
    elsif HARDCODED_ATTRIBUTES.include? k
      power.send((k + "=").to_sym, v1)
      nil
    else
      if k == "special" and !!v1.match("twice per encounter")
        @duplicate = true
      end
      power.power_attributes.new(name: k, text: v1)
    end
  end

  # Imports powers for an already processed character
  # Character, Nokogiri::XML -> void
  def self.import_powers(char, xml)
    duplicates = []
    self.powers(xml).collect do |p|

      power = char.powers.new
      @duplicate = false
      attributes = p.collect do |attr|
        self.import_power_atributes(power, attr)
      end.compact

      if @duplicate
        dup_power = power.dup
        dup_attributes = p.collect do |attr|
          self.import_power_atributes(dup_power, attr)
        end.compact
        duplicates << [dup_power, dup_attributes]
      end

      [power, attributes.flatten]
    end + duplicates
  end

  # Imports powers for an already processed character
  # Character, Nokogiri::XML -> void
  def self.import_rituals(char, xml)
    self.rituals(xml).collect do |p|
      ritual = char.rituals.new
      attributes = p.collect do |attr|
        v = attr.last
        k = attr.first
        v1 = (Array === v)? v.first : v
        if RITUAL_ATTRIBUTES.include? k
          ritual.send((k + "=").to_sym, v1)
          nil
        else
          ritual.ritual_attributes.new(name: k, text: v1)
        end
      end.compact
      [ritual, attributes.flatten]
    end
  end

  # Reads skills, defenses and misc. stats from xml file
  # Nokogiri::XML -> {string -> variable}
  def self.misc_stats(xml)
    (DEFENSES + MISC_STATS).collect do |stat|
      xpath = "//StatBlock/Stat[alias[@name=\"#{stat}\"]]/@value"
      [stat.strip.tr(" ", "_").underscore, xml.xpath(xpath)[0].value.to_i]
    end.compact.to_h
  end

  # Read skills, if they've been trained and what stat is associated with it
  def self.skills(xml)
    SKILLS.collect do |skill|
      s = xml.xpath("//StatBlock/Stat[alias[@name=\"#{skill}\"]]").first
      value = s.attributes["value"].value
      name = skill.underscore
      stat = s.xpath("statadd[@type=\"Ability\"]/@statlink").first.value
      trained = xml.xpath("//StatBlock/Stat[alias[@name=\"#{skill} Trained\"]]/@value")
      trained = trained.first.value.to_i
      {name: name, value: value, stat: stat, trained: trained}
    end
  end

  # Reads character details from xml file
  # Nokogiri::XML -> {string -> variable}
  def self.details(xml)
    xml.xpath("//Details/node()[text() != \"  \"]").collect do |detail|
      next if detail.name == "Portrait"
      [detail.name.underscore, detail.text.strip]
    end.compact.to_h
  end

  # Reads "Hidden" details like race and class
  def self.additional_details(xml)
    ADDITIONAL_DETAILS.collect do |d|
      value = xml.xpath("//RulesElement[@type=\"#{d}\"]/@name").first.value
      key = (d == "Class")? "klass" : d.underscore
      [key, value]
    end.compact.to_h
  end

  # Reads character ability scores from xml file
  # Nokogiri::XML -> {string -> integer}
  def self.ability_scores(xml)
    xml.xpath("//AbilityScores/node()").select{|d| d.present?}.collect do |ability|
      [ability.name.underscore, ability.attributes["score"].value.to_i]
    end.compact.to_h
  end

  # Reads powers from xml file
  # Nokogiri::XML -> {string -> variable}
  def self.powers(xml)
    power = xml.xpath("//PowerStats/Power").collect do |p|
      h1 = [["name", p.attributes["name"].value]]

      children = p.children.select{|c| c.present?}
      h2 = children.collect do |c|
        next unless c.attributes.has_key? "name"
        key = c.attributes["name"].value.strip.tr(" ", "_").underscore
        next if c.text[1] == "_" or (key[0] == "_" and key != "_parent_power")
        next if c.attributes["name"].value == "Class"
        if c.name.strip == "Weapon"
          ["weapon", self.weapon(c)]
        elsif key == "_parent_power"
          ["child", true]
        else
          [key, c.text.strip]
        end
      end.compact

      h1 + h2
    end
    power
  end

  # Reads rituals from xml file
  # Nokogiri::XML -> {string -> variable}
  def self.rituals(xml)
    ritual = xml.xpath('//LootTally//RulesElement[@type="Ritual"]').collect do |p|
      h1 = [
        ["name", p.attributes["name"].value],
        ["description", desc = p.xpath("text()[normalize-space()]").text.strip]
      ]

      children = p.children.select{|c| c.present?}
      h2 = children.collect do |c|
        next unless c.attributes.has_key? "name"
        key = c.attributes["name"].value.strip.tr(" ", "_").underscore
        [key, c.text.strip]
      end.compact

      h1 + h2
    end
    ritual
  end

  def self.feats(xml)
    FEATS.collect do |type|
      xml.xpath("//RulesElement[@type=\"#{type}\"][specific]").collect do |f|
        next if f.xpath("specific[@name=\"_CS_ShortDescription\"]").text.strip == "@"
        name = f.xpath("@name").to_s
        desc = f.xpath("text()[normalize-space()]").text.strip
        short = f.xpath("specific[@name=\"Short Description\"]").text.strip
        {name: name, description: desc, short: short}
      end
    end.flatten.compact
  end


  def self.weapon(wpn)
    h1 = {"name" => wpn.attributes["name"].value}

    children = wpn.children.select{|c| c.present?}

    h2 = children.collect do |c|
      [c.name.underscore, c.text.strip]
    end.compact.to_h

    h1.merge h2
  end
end
