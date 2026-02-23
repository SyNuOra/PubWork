-- liquibase formatted sql
-- changeset SYAPEX:1771865126766 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_paths_target_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_paths_target_fk.sql:null:19031ce468f271dba618cfb58d64d508d3c2f1d3:create

alter table syapex.ggops_paths
    add constraint ggops_paths_target_fk
        foreign key ( target )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;

