-- Tabela de respostas do quiz (registros anônimos)
-- Criada em: 29/05/2026
-- Propósito: capturar perfil de audiência e comportamento no quiz
--            sem exigir cadastro ou autenticação do visitante.

create table quiz_responses (
  id           uuid        default gen_random_uuid() primary key,
  created_at   timestamptz default now(),
  perfil       text,
  risco        text,
  score        integer,
  dor          text,
  respostas    jsonb,
  concluido    boolean     default false,
  abandonou_em integer,
  session_id   text
);

-- RLS: apenas insert público — sem leitura pelo browser
alter table quiz_responses enable row level security;

create policy "insert_anonimo" on quiz_responses
  for insert with check (true);

-- Queries úteis para análise de audiência:
--
-- Perfil mais frequente:
--   select perfil, count(*) from quiz_responses group by perfil order by count desc;
--
-- Nível de risco mais frequente:
--   select risco, count(*) from quiz_responses group by risco order by count desc;
--
-- Dor principal:
--   select dor, count(*) from quiz_responses group by dor order by count desc;
--
-- Taxa de conclusão:
--   select concluido, count(*) from quiz_responses group by concluido;
--
-- Pergunta onde mais abandona:
--   select abandonou_em, count(*) from quiz_responses
--   where concluido = false group by abandonou_em order by abandonou_em;
--
-- Perfil autônomo com risco crítico:
--   select * from quiz_responses
--   where perfil like '%autonomo%' and risco = 'critico';
