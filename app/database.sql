
-- Database Schema for Tanatswa's Youth Empowerment Hub


-- 1. Delete existing tables in reverse order of dependency if they exist
DROP TABLE IF EXISTS public.watch_history CASCADE;
DROP TABLE IF EXISTS public.user_progress CASCADE;
DROP TABLE IF EXISTS public.admin_logs CASCADE;
DROP TABLE IF EXISTS public.resources CASCADE;
DROP TABLE IF EXISTS public.videos CASCADE;
DROP TABLE IF EXISTS public.programs CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- 2. INDEPENDENT TABLES 

-- Users Table
CREATE TABLE public.users (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  password text NOT NULL,
  role text NOT NULL DEFAULT 'USER', -- Changed from USER-DEFINED for compatibility
  level text NOT NULL,               -- Changed from USER-DEFINED for compatibility
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);

-- Programs Table
CREATE TABLE public.programs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  cover_image text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT programs_pkey PRIMARY KEY (id)
);

-- 3. DEPENDENT TABLES 

-- Admin Logs (References Users)
CREATE TABLE public.admin_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  admin_id uuid NOT NULL,
  action text NOT NULL,
  entity text NOT NULL,
  entity_id uuid,
  logged_at timestamp with time zone DEFAULT now(),
  CONSTRAINT admin_logs_pkey PRIMARY KEY (id),
  CONSTRAINT admin_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id)
);

-- Videos (References Programs)
CREATE TABLE public.videos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  program_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  youtube_url text NOT NULL,
  audience text,
  order_index integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT videos_pkey PRIMARY KEY (id),
  CONSTRAINT videos_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id)
);

-- Resources (References Programs)
CREATE TABLE public.resources (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  program_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  file_url text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT resources_pkey PRIMARY KEY (id),
  CONSTRAINT resources_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id)
);

-- User Progress (References Users and Programs)
CREATE TABLE public.user_progress (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  program_id uuid NOT NULL,
  total_videos integer DEFAULT 0,
  watched_videos integer DEFAULT 0,
  percent_complete numeric DEFAULT 0,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_progress_pkey PRIMARY KEY (id),
  CONSTRAINT user_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT user_progress_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id)
);

-- Watch History (References Users and Videos)
CREATE TABLE public.watch_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  video_id uuid NOT NULL,
  last_timestamp integer DEFAULT 0,
  times_watched integer DEFAULT 0,
  is_completed boolean DEFAULT false,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT watch_history_pkey PRIMARY KEY (id),
  CONSTRAINT watch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT watch_history_video_id_fkey FOREIGN KEY (video_id) REFERENCES public.videos(id)
);