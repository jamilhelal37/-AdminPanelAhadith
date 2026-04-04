create index if not exists idx_books_muhaddith on public.books(muhaddith);

create index if not exists idx_ahadith_sub_valid on public.ahadith(sub_valid);
create index if not exists idx_ahadith_explaining on public.ahadith(explaining);
create index if not exists idx_ahadith_muhaddith_ruling on public.ahadith(muhaddith_ruling);
create index if not exists idx_ahadith_final_ruling on public.ahadith(final_ruling);
create index if not exists idx_ahadith_rawi on public.ahadith(rawi);
create index if not exists idx_ahadith_source on public.ahadith(source);
create index if not exists idx_ahadith_search_text on public.ahadith(search_text);
create index if not exists idx_ahadith_search_text_trgm on public.ahadith using gin (search_text gin_trgm_ops);

create index if not exists idx_fake_ahadith_sub_valid on public.fake_ahadith(sub_valid);
create index if not exists idx_fake_ahadith_ruling on public.fake_ahadith(ruling);
create index if not exists idx_fake_ahadith_search_text on public.fake_ahadith(search_text);
create index if not exists idx_fake_ahadith_search_text_trgm on public.fake_ahadith using gin (search_text gin_trgm_ops);

create index if not exists idx_comments_hadith on public.comments(hadith);
create index if not exists idx_comments_user on public.comments("user");

create index if not exists idx_favorite_user on public.favorite("user");
create index if not exists idx_favorite_hadith on public.favorite(hadith);

create index if not exists idx_questions_asker on public.questions(asker);
create index if not exists idx_search_history_user on public.search_history("user");

create index if not exists idx_similar_ahadith_main on public.similar_ahadith(main_hadith);
create index if not exists idx_similar_ahadith_sim on public.similar_ahadith(sim_hadith);

create index if not exists idx_topic_class_topic on public.topic_class(topic);
create index if not exists idx_topic_class_hadith on public.topic_class(hadith);

create index if not exists idx_search_history_ishadith on public.search_history(ishadith);

create index if not exists idx_ruling_created_by on public.ruling(created_by);
create index if not exists idx_ruling_updated_by on public.ruling(updated_by);
create index if not exists idx_muhaddiths_created_by on public.muhaddiths(created_by);
create index if not exists idx_muhaddiths_updated_by on public.muhaddiths(updated_by);
create index if not exists idx_rawis_created_by on public.rawis(created_by);
create index if not exists idx_rawis_updated_by on public.rawis(updated_by);
create index if not exists idx_explaining_created_by on public.explaining(created_by);
create index if not exists idx_explaining_updated_by on public.explaining(updated_by);
create index if not exists idx_books_created_by on public.books(created_by);
create index if not exists idx_books_updated_by on public.books(updated_by);
create index if not exists idx_topics_created_by on public.topics(created_by);
create index if not exists idx_topics_updated_by on public.topics(updated_by);
create index if not exists idx_ahadith_created_by on public.ahadith(created_by);
create index if not exists idx_ahadith_updated_by on public.ahadith(updated_by);
create index if not exists idx_fake_ahadith_created_by on public.fake_ahadith(created_by);
create index if not exists idx_fake_ahadith_updated_by on public.fake_ahadith(updated_by);
create index if not exists idx_questions_updated_by on public.questions(updated_by);
create index if not exists idx_similar_ahadith_created_by on public.similar_ahadith(created_by);
create index if not exists idx_similar_ahadith_updated_by on public.similar_ahadith(updated_by);
create index if not exists idx_topic_class_created_by on public.topic_class(created_by);
create index if not exists idx_topic_class_updated_by on public.topic_class(updated_by);

create index if not exists idx_admin_audit_log_table_name on public.admin_audit_log(table_name);
create index if not exists idx_admin_audit_log_record_id on public.admin_audit_log(record_id);
create index if not exists idx_admin_audit_log_actor on public.admin_audit_log(actor_user_id);
create index if not exists idx_admin_audit_log_created_at on public.admin_audit_log(created_at);


create index if not exists idx_pro_upgrade_requests_user_id on public.pro_upgrade_requests(user_id);
create index if not exists idx_pro_upgrade_requests_created_at on public.pro_upgrade_requests(created_at);
create index if not exists idx_pro_upgrade_requests_status_created_at on public.pro_upgrade_requests(status, created_at desc);

create index if not exists idx_pro_upgrade_certificates_request_id on public.pro_upgrade_certificates(request_id);
create index if not exists idx_pro_upgrade_certificates_created_at on public.pro_upgrade_certificates(created_at);

create index if not exists idx_pro_upgrade_decisions_user_id on public.pro_upgrade_decisions(user_id);
create index if not exists idx_pro_upgrade_decisions_reviewed_by on public.pro_upgrade_decisions(reviewed_by);
create index if not exists idx_pro_upgrade_decisions_approved on public.pro_upgrade_decisions(approved);
create index if not exists idx_pro_upgrade_decisions_created_at on public.pro_upgrade_decisions(created_at);
