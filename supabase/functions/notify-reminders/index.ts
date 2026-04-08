import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { sendNotification } from '../_shared/fcm.ts'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (_req: Request) => {
  try {
    await checkBirthdays()
    await checkEvents()
    return new Response('ok', { status: 200 })
  } catch (e) {
    console.error(e)
    return new Response('error', { status: 500 })
  }
})

// ─── Дни рождения ─────────────────────────────────────────────────────────────

async function checkBirthdays() {
  // Загружаем всех пользователей с датой рождения, фильтруем в JS по MM-DD
  const { data: users } = await supabase
    .from('users_info')
    .select('uuid, name, birth_date')
    .not('birth_date', 'is', null)

  if (!users?.length) return

  for (const daysAhead of [1, 3, 7]) {
    const targetMD = isoDate(daysAhead).substring(5) // MM-DD

    const matched = users.filter(
      (u) => (u.birth_date as string).substring(5) === targetMD
    )

    for (const user of matched) {
      const friends = await getFriendsWithToken(user.uuid)
      const label = daysLabel(daysAhead)

      for (const friend of friends) {
        await sendNotification(
          friend.fcm_token,
          '🎂 День рождения друга',
          `${label} у ${user.name} день рождения! Посмотри его вишлист`,
          { type: 'birthday', uuid: user.uuid }
        )
      }
    }
  }
}

// ─── События (event_date у комнат) ────────────────────────────────────────────

async function checkEvents() {
  for (const daysAhead of [1, 3, 7]) {
    const target = isoDate(daysAhead)

    const { data: rooms } = await supabase
      .from('rooms')
      .select('id, name, owner, event_date')
      .eq('event_date', target)
      .eq('is_public', true)

    if (!rooms?.length) continue

    for (const room of rooms) {
      const { data: ownerData } = await supabase
        .from('users_info')
        .select('name')
        .eq('uuid', room.owner)
        .single()

      const ownerName: string = ownerData?.name ?? 'Друг'
      const friends = await getFriendsWithToken(room.owner)
      const label = daysLabel(daysAhead)

      for (const friend of friends) {
        await sendNotification(
          friend.fcm_token,
          '🎁 Скоро событие',
          `${label} у ${ownerName} — «${room.name}». Успей выбрать подарок!`,
          { type: 'event', roomId: String(room.id) }
        )
      }
    }
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

async function getFriendsWithToken(
  uuid: string
): Promise<{ fcm_token: string }[]> {
  const { data: requests } = await supabase
    .from('friend_requset')
    .select('sender_id, receiver_id')
    .eq('status', 'accepted')
    .or(`sender_id.eq.${uuid},receiver_id.eq.${uuid}`)

  if (!requests?.length) return []

  const friendUuids = requests.map((r: any) =>
    r.sender_id === uuid ? r.receiver_id : r.sender_id
  )

  const { data: friends } = await supabase
    .from('users_info')
    .select('fcm_token')
    .in('uuid', friendUuids)
    .not('fcm_token', 'is', null)

  return (friends ?? []) as { fcm_token: string }[]
}

function isoDate(daysAhead: number): string {
  const d = new Date()
  d.setDate(d.getDate() + daysAhead)
  return d.toISOString().substring(0, 10)
}

function daysLabel(daysAhead: number): string {
  if (daysAhead === 1) return 'Завтра'
  if (daysAhead === 3) return 'Через 3 дня'
  return 'Через неделю'
}
