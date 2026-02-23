create or replace editionable trigger syapex.ggops_paths_biu before
    insert or update on syapex.ggops_paths
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
end ggops_paths_biu;
/

alter trigger syapex.ggops_paths_biu enable;


-- sqlcl_snapshot {"hash":"e6c243014af7526a008037b16d7c59530d61fe2e","type":"TRIGGER","name":"GGOPS_PATHS_BIU","schemaName":"SYAPEX","sxml":""}