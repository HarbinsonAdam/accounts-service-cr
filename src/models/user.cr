class User < Granite::Base
  connection mysql
  table users

  column id : Int32, primary: true
  column first_name : String
  column last_name : String
  column dob : Time
  column password : String
  column email : String

  timestamps
end