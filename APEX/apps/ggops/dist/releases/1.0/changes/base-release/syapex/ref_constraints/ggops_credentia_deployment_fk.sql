-- liquibase formatted sql
-- changeset SYAPEX:1771865126632 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_credentia_deployment_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_credentia_deployment_fk.sql:null:9bf2417a453b03858c13c4e2d78efd2f73bb5053:create

alter table syapex.ggops_credential_domains
    add constraint ggops_credentia_deployment_fk
        foreign key ( deployment_id )
            references syapex.ggops_deployments ( deployment_id )
                on delete cascade
        enable;

