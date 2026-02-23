-- liquibase formatted sql
-- changeset SYAPEX:1771865126897 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_processes_credential_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_processes_credential_fk.sql:null:991a12242cda57c7472483cea6f1a7d3c284f332:create

alter table syapex.ggops_processes
    add constraint ggops_processes_credential_fk
        foreign key ( credential_id )
            references syapex.ggops_credentials ( user_id )
                on delete cascade
        enable;

