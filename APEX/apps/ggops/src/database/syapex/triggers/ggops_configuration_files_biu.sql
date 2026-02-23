create or replace editionable trigger syapex.ggops_configuration_files_biu before
    insert or update on syapex.ggops_configuration_files
    for each row
begin
    if inserting then
        :new.created := localtimestamp;
        :new.created_by := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        );
    end if;

    :new.updated := localtimestamp;
    :new.updated_by := coalesce(
        sys_context('APEX$SESSION', 'APP_USER'),
        user
    );
end ggops_configuration_files_biu;
/

alter trigger syapex.ggops_configuration_files_biu enable;


-- sqlcl_snapshot {"hash":"b38a481bab8d652ebddb619a5f7df929f57906ee","type":"TRIGGER","name":"GGOPS_CONFIGURATION_FILES_BIU","schemaName":"SYAPEX","sxml":""}