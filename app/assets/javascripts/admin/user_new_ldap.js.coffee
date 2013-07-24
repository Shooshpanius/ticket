$(document).ready ($) ->





  $("#user_new_ldap").validate


    submitHandler: (form) ->
      queryString = $("#user_new_ldap").serialize()
      $.ajax
        url: "/admin/users/srv_user_new_ldap"
        type: "POST"
        async: false
        data: queryString
        success: (msg) ->
          location.replace ""

      false
