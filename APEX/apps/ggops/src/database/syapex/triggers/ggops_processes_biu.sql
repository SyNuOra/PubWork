create or replace editionable trigger syapex.ggops_processes_biu before
    insert or update on syapex.ggops_processes
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
end ggops_processes_biu;
/

alter trigger syapex.ggops_processes_biu enable;


-- sqlcl_snapshot {"hash":"c2c88ef87786cc4f0cb197de13bd5deecb0f22d4","type":"TRIGGER","name":"GGOPS_PROCESSES_BIU","schemaName":"SYAPEX","sxml":""}