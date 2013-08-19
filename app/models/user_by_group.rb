class UserByGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user



  def UserByGroup.users_in_group(group_id)
    return  UserByGroup.find_by_sql("SELECT * FROM user_by_groups
                                        LEFT JOIN users ON user_by_groups.user_id = users.id
                                        WHERE user_by_groups.group_id = #{group_id}")
  end


  def UserByGroup.groups_for_user(user_id)
    groups_query = UserByGroup.find_by_sql("SELECT user_id as user_id, group_id as id FROM user_by_groups

                                        LEFT JOIN groups ON user_by_groups.id = groups.id
                                        WHERE user_by_groups.user_id = #{user_id}")

    return groups_query
  end


  def UserByGroup.is_user_in_group(user_id, group_id)
    groups_query = UserByGroup.find_by_sql("SELECT group_id as id FROM user_by_groups

                                        LEFT JOIN groups ON user_by_groups.id = groups.id
                                        WHERE user_by_groups.user_id = #{user_id}
                                          AND group_id = #{group_id}




                                      ")

    return groups_query
  end

end
