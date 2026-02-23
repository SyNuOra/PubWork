-- liquibase formatted sql
-- changeset SYAPEX:1771865128179 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_credential_domains_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_credential_domains_biu.sql:null:fc23622242930864ee5735a95b3e74b4112216fa:create

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

