create or replace editionable trigger syapex.ggops_credential_domains_biu before
    insert or update on syapex.ggops_credential_domains
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
end ggops_credential_domains_biu;
/

alter trigger syapex.ggops_credential_domains_biu enable;


-- sqlcl_snapshot {"hash":"407403460b7c91a2a65aefc5e78e742082e85df5","type":"TRIGGER","name":"GGOPS_CREDENTIAL_DOMAINS_BIU","schemaName":"SYAPEX","sxml":""}