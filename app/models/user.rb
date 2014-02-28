class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :characters

  def import_character(user_params)
    read_file = user_params[:attachment].read

    c = Import.import_file(read_file)
    c.user_id = self.id

    # Save character save for further reference
    file_name = "#{c.klass}_#{c.level}_#{Time.now.to_i}.dnd4e"
    c.file_name = file_name

    path = Rails.root.join('public', 'uploads', file_name)
    new_file = File.open(path, 'w:ASCII-8BIT')
    new_file.write(read_file)
    new_file.close
    c.save
  end
end
