module UsersHelper
   def users_exist?
      return User.count > 0 ? true : false
   end   
end
