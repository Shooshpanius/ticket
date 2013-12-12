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

  def UserByGroup.groups_for_user_leader(user_id)
    groups_query = UserByGroup.find_by_sql("SELECT user_id as user_id, group_id as id FROM user_by_groups

                                        LEFT JOIN groups ON user_by_groups.group_id = groups.id
                                        WHERE user_by_groups.user_id = #{user_id}
                                          AND groups.leader = #{user_id}")

    return groups_query
  end

  def UserByGroup.is_user_in_group(user_id, group_id)
    groups_query = UserByGroup.find_by_sql("SELECT group_id as id FROM user_by_groups

                                        LEFT JOIN groups ON user_by_groups.id = groups.id
                                        WHERE user_by_groups.user_id = #{user_id}
                                          AND group_id = #{group_id}")

    return groups_query
  end


  def UserByGroup.get_subordinates(user_id)

    my_groups = ""
    UserByGroup.groups_for_user_leader(user_id).map{|x| x.id}.each do |y|
      my_groups = my_groups + (y.to_s+",")
    end
    my_groups = my_groups + ")"
    my_groups = my_groups.gsub(/(\,\))/,'')

    if my_groups != ")"
      my_subordinate_groups = UserByGroup.find_by_sql("SELECT users.id, users.login FROM user_by_groups
                                          LEFT JOIN users ON user_by_groups.user_id = users.id
                                          WHERE user_by_groups.group_id IN (#{my_groups})
                                            AND users.id <> #{user_id}
                                          GROUP BY users.id ")

    else
      my_subordinate_groups = []
    end

    return my_subordinate_groups

  end

end
