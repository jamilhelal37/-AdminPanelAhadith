create or replace function public.set_fake_ahadith_text_variants()
returns trigger
language plpgsql
as $$
begin
	if new.text is null then
		new.normal_text := null;
		new.search_text := null;
		return new;
	end if;

	new.normal_text := public.normalize_arabic_diacritics(new.text);
	new.search_text := public.normalize_arabic_search_text(new.text);

	return new;
end;
$$;