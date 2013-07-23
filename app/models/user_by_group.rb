class UserByGroup < ActiveRecord::Base
  belongs_to :groups
  belongs_to :users



  def UserByGroup.users_in_group(group_id)
    return  UserByGroup.find_by_sql("SELECT * FROM user_by_groups
                                        LEFT JOIN users ON user_by_groups.users_id = users.id
                                        WHERE user_by_groups.groups_id = #{group_id}")
  end


  def UserByGroup.groups_for_user(user_id)
    groups_query = UserByGroup.find_by_sql("SELECT users_id as users_id, groups_id as id FROM user_by_groups

                                        LEFT JOIN groups ON user_by_groups.id = groups.id
                                        WHERE user_by_groups.users_id = #{user_id}")

    return groups_query
  end


end
