DECLARE
    in_id_persona             number;
    on_nuevo_salario          NUMBER;
    on_id_respuesta           NUMBER;
    on_categoria_id_excepcion NUMBER;
    ov_msj_excepcion          VARCHAR2(200);
    ov_msj_error_tecnico      VARCHAR2(200);
BEGIN
    in_id_persona              := 53;
    sp_ajustarsalario(in_id_persona              => in_id_persona
                     , on_nuevo_salario          => on_nuevo_salario
                     , on_id_respuesta           => on_id_respuesta
                     , on_categoria_id_excepcion => on_categoria_id_excepcion
                     , ov_msj_excepcion          => ov_msj_excepcion
                     , ov_msj_error_tecnico      => ov_msj_error_tecnico);
    DBMS_OUTPUT.PUT_LINE('ON_ID_RESPUESTA           = ' || ON_ID_RESPUESTA);
    DBMS_OUTPUT.PUT_LINE('ON_NUEVO_SALARIO          = ' || ON_NUEVO_SALARIO);
    DBMS_OUTPUT.PUT_LINE('ON_CATEGORIA_ID_EXCEPCION = ' || ON_CATEGORIA_ID_EXCEPCION);
    DBMS_OUTPUT.PUT_LINE('OV_MSJ_EXCEPCION          = ' || OV_MSJ_EXCEPCION);
    DBMS_OUTPUT.PUT_LINE('OV_MSJ_ERROR_TECNICO      = ' || OV_MSJ_ERROR_TECNICO);
END;
