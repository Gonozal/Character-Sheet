class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :characters

  def promote_to_admin
    if id == 1
      self.admin = true
    end
  end

  def import_character(user_params)
    f = user_params[:attachment]

    c = Import.import_file(f.read)
    c.user_id = id
    # Save character save for further reference
    file_name = "#{c.klass}_#{c.level}_#{Time.now.to_i}.dnd4e"
    c.file_name = file_name

    path = Rails.root.join('public', 'uploads', file_name)
    File.open(path, 'wb') do |file|
      write = file.write(f.read)
    end
    c.save
  end
end
