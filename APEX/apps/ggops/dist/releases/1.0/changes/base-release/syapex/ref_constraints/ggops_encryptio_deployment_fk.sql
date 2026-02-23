-- liquibase formatted sql
-- changeset SYAPEX:1771865126664 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_encryptio_deployment_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_encryptio_deployment_fk.sql:null:ca4f45a5c0aa820bbbd5630df66d515d7f3d8141:create

alter table syapex.ggops_encryption_profiles
    add constraint ggops_encryptio_deployment_fk
        foreign key ( deployment_id )
            references syapex.ggops_deployments ( deployment_id )
                on delete cascade
        enable;

