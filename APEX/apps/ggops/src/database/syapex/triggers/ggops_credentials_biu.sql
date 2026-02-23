create or replace editionable trigger syapex.ggops_credentials_biu before
    insert or update on syapex.ggops_credentials
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
end ggops_credentials_biu;
/

alter trigger syapex.ggops_credentials_biu enable;


-- sqlcl_snapshot {"hash":"4d6063938e90c2548e33b5e0d83d32b3006e7752","type":"TRIGGER","name":"GGOPS_CREDENTIALS_BIU","schemaName":"SYAPEX","sxml":""}