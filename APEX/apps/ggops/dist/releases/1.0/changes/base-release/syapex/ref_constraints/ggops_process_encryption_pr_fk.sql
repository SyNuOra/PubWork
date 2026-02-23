-- liquibase formatted sql
-- changeset SYAPEX:1771865126863 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_process_encryption_pr_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_process_encryption_pr_fk.sql:null:c0f938105341b33e3c5cf9001a9ddd6f3b1b0d58:create

alter table syapex.ggops_processes
    add constraint ggops_process_encryption_pr_fk
        foreign key ( encryption_profile )
            references syapex.ggops_encryption_profiles ( profile_id )
                on delete cascade
        enable;

