-- liquibase formatted sql
-- changeset SYAPEX:1771865126932 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_processes_deployment_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_processes_deployment_fk.sql:null:51c31e34ba905c528e6f3c60e707466d7993da48:create

alter table syapex.ggops_processes
    add constraint ggops_processes_deployment_fk
        foreign key ( deployment_id )
            references syapex.ggops_deployments ( deployment_id )
                on delete cascade
        enable;

