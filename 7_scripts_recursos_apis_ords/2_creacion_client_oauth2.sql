BEGIN
  OAUTH.create_client(
    p_name            => 'personas_client',
    p_grant_type      => 'client_credentials',
    p_owner           => 'clarap',
    p_description     => 'C2H',
    p_support_email   => 'leonel.pedrozo.quiroz@gmail.com',
    p_privilege_names => 'personas_privilige'
  );
  COMMIT;
  OAUTH.grant_client_role(
    p_client_name => 'personas_client',
    p_role_name   => 'personas_role'
  );
  COMMIT;
END;

