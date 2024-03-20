struct AccountsService::V1::AccountPayload
  include JSON::Serializable

  getter first_name : String
  getter last_name : String
  getter dob : Time
  getter password : String
  getter email : String
end