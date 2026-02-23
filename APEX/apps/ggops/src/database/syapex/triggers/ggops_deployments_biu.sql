create or replace editionable trigger syapex.ggops_deployments_biu before
    insert or update on syapex.ggops_deployments
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
end ggops_deployments_biu;
/

alter trigger syapex.ggops_deployments_biu enable;


-- sqlcl_snapshot {"hash":"93d7a126af56c9b9cf4ff08f6b52c3f9d7182f0f","type":"TRIGGER","name":"GGOPS_DEPLOYMENTS_BIU","schemaName":"SYAPEX","sxml":""}