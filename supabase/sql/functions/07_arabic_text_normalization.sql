-- Arabic text normalization helpers
-- 1) normalize_arabic_diacritics: remove tashkeel only
-- 2) normalize_arabic_search_text: remove tashkeel, normalize hamza/alef, remove punctuation, collapse spaces

create or replace function public.normalize_arabic_diacritics(p_text text)
returns text
language plpgsql
immutable
as $$
declare
  v_text text;
begin
  if p_text is null then
    return null;
  end if;

  v_text := p_text;

  -- Remove Arabic diacritics, Quranic marks, and tatweel.
  v_text := translate(
    v_text,
    U&'\0610\0611\0612\0613\0614\0615\0616\0617\0618\0619\061A\064B\064C\064D\064E\064F\0650\0651\0652\0653\0654\0655\0656\0657\0658\0659\065A\065B\065C\065D\065E\065F\0670\06D6\06D7\06D8\06D9\06DA\06DB\06DC\06DF\06E0\06E1\06E2\06E3\06E4\06E7\06E8\06EA\06EB\06EC\06ED\0640',
    ''
  );

  return v_text;
end;
$$;

create or replace function public.normalize_arabic_search_text(p_text text)
returns text
language plpgsql
immutable
as $$
declare
  v_text text;
begin
  if p_text is null then
    return null;
  end if;

  v_text := public.normalize_arabic_diacritics(p_text);

  -- Normalize alef variants.
  v_text := replace(v_text, U&'\0623', U&'\0627');
  v_text := replace(v_text, U&'\0625', U&'\0627');
  v_text := replace(v_text, U&'\0622', U&'\0627');
  v_text := replace(v_text, U&'\0671', U&'\0627');

  -- Remove/normalize hamza-bearing letters.
  v_text := replace(v_text, U&'\0624', U&'\0648');
  v_text := replace(v_text, U&'\0626', U&'\064A');
  v_text := replace(v_text, U&'\0621', '');

  -- Remove punctuation (Arabic + generic punctuation), keep letters/digits/spaces.
  v_text := regexp_replace(v_text, '[[:punct:]]', ' ', 'g');

  -- Normalize spaces.
  v_text := regexp_replace(v_text, '\s+', ' ', 'g');
  v_text := btrim(v_text);

  return v_text;
end;
$$;
