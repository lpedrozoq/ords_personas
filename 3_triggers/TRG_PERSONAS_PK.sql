CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_RUMA01W1"."TRG_PERSONAS_PK" 
   before insert on "WKSP_RUMA01W1"."PERSONAS" 
   for each row 
begin  
   if inserting then 
      if :NEW."ID" is null then 
         select SEQ_PERSONAS.nextval into :NEW."ID" from dual; 
      end if; 
   end if; 
end;
/
