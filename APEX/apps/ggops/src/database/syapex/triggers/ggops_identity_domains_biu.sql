create or replace editionable trigger syapex.ggops_identity_domains_biu before
    insert or update on syapex.ggops_identity_domains
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
end ggops_identity_domains_biu;
/

alter trigger syapex.ggops_identity_domains_biu enable;


-- sqlcl_snapshot {"hash":"57a6f1f89f6830a1d6af9372a7d2169042687125","type":"TRIGGER","name":"GGOPS_IDENTITY_DOMAINS_BIU","schemaName":"SYAPEX","sxml":""}