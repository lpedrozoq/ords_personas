declare
    lv_json varchar2(4000);
begin
    update personas a
    set a.estado = 'INACTIVO'
    where a.id = 169;
    if sql%rowcount > 0 then
        commit;
        lv_json := '{
                   "codigo_respuesta": 0,
                   "categoria_respuesta": null,
                   "descripcion_excepcion": null,
                   "descripcion_tecnica": null
                   }';
        dbms_output.put_line('0: ' || lv_json);                   
    else
        lv_json := '{
                   "codigo_respuesta": -1,
                   "categoria_respuesta": 1020,
                   "descripcion_excepcion": "No existe registro para eliminar",
                   "descripcion_tecnica": null
                   }';
        dbms_output.put_line('1: ' || lv_json);                   
    end if;
exception
    when others then
        lv_json := '{
                   "codigo_respuesta": -1,
                   "categoria_respuesta": 1040,
                   "descripcion_excepcion": "Ha ocurrido un error al eliminar el registro",
                   "descripcion_tecnica": "' || REPLACE(substr(sqlerrm,1,150),'"') ||' 
                   }';
    dbms_output.put_line('-1: ' || lv_json);                   
end;
