class UserByGroup < ActiveRecord::Base
  belongs_to :groups
  belongs_to :users



  def UserByGroup.users_in_group(group_id)
    return  UserByGroup.find_by_sql("SELECT * FROM user_by_groups
                                        LEFT JOIN users ON user_by_groups.users_id = users.id
                                        WHERE user_by_groups.groups_id = #{group_id}")
  end

end
