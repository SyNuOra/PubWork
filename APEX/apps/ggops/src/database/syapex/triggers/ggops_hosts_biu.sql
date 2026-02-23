create or replace editionable trigger syapex.ggops_hosts_biu before
    insert or update on syapex.ggops_hosts
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
end ggops_hosts_biu;
/

alter trigger syapex.ggops_hosts_biu enable;


-- sqlcl_snapshot {"hash":"f3195e46ff41e6d2e7ba4d98a2a06a1b749f0110","type":"TRIGGER","name":"GGOPS_HOSTS_BIU","schemaName":"SYAPEX","sxml":""}