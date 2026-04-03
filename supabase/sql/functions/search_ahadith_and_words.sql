-- Search function with word-by-word AND matching on normalized text.
-- Input query is normalized exactly like search_text.

create or replace function public.search_ahadith_and_words(
  p_query text,
  p_limit integer default 50,
  p_offset integer default 0
)
returns table (
  id uuid,
  hadith_number integer,
  text text,
  normal_text text,
  search_text text,
  matched_terms integer
)
language plpgsql
stable
as $$
declare
  v_query text;
  v_terms text[];
begin
  v_query := public.normalize_arabic_search_text(p_query);

  if v_query is null or v_query = '' then
    return;
  end if;

  select array_agg(distinct t)
  into v_terms
  from unnest(regexp_split_to_array(v_query, '\s+')) as t
  where char_length(t) > 0;

  if v_terms is null or array_length(v_terms, 1) = 0 then
    return;
  end if;

  return query
  with scored as (
    select
      a.id,
      a.hadith_number,
      a.text,
      a.normal_text,
      a.search_text,
      (
        select count(*)::integer
        from unnest(v_terms) as term
        where a.search_text like '%' || term || '%'
      ) as matched_terms
    from public.ahadith a
    where (
      select bool_and(a.search_text like '%' || term || '%')
      from unnest(v_terms) as term
    )
  )
  select
    s.id,
    s.hadith_number,
    s.text,
    s.normal_text,
    s.search_text,
    s.matched_terms
  from scored s
  order by s.matched_terms desc, s.id asc
  limit greatest(coalesce(p_limit, 50), 1)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;
