-- liquibase formatted sql
-- changeset SYAPEX:1771865126732 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_paths_source_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_paths_source_fk.sql:null:29443a3ef917676455cd39119f4510c235500bb9:create

alter table syapex.ggops_paths
    add constraint ggops_paths_source_fk
        foreign key ( source )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;

