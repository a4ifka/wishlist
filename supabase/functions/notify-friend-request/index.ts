import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { sendNotification } from '../_shared/fcm.ts'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req: Request) => {
  try {
    const payload = await req.json()
    const record = payload.record

    if (payload.type === 'INSERT') {
      // Новая заявка в друзья → уведомляем получателя
      await notifyNewRequest(record)
    } else if (payload.type === 'UPDATE' && record.status === 'accepted') {
      // Заявка принята → уведомляем отправителя
      await notifyAccepted(record)
    }

    return new Response('ok', { status: 200 })
  } catch (e) {
    console.error(e)
    return new Response('error', { status: 500 })
  }
})

async function notifyNewRequest(record: any) {
  const { data: sender } = await supabase
    .from('users_info')
    .select('name')
    .eq('uuid', record.sender_id)
    .single()

  const { data: receiver } = await supabase
    .from('users_info')
    .select('fcm_token')
    .eq('uuid', record.receiver_id)
    .single()

  if (!receiver?.fcm_token) return

  await sendNotification(
    receiver.fcm_token,
    '👋 Новая заявка в друзья',
    `${sender?.name ?? 'Кто-то'} хочет добавить тебя в друзья`,
    { type: 'friend_request', senderUuid: record.sender_id }
  )
}

async function notifyAccepted(record: any) {
  const { data: receiver } = await supabase
    .from('users_info')
    .select('name')
    .eq('uuid', record.receiver_id)
    .single()

  const { data: sender } = await supabase
    .from('users_info')
    .select('fcm_token')
    .eq('uuid', record.sender_id)
    .single()

  if (!sender?.fcm_token) return

  await sendNotification(
    sender.fcm_token,
    '✅ Заявка принята',
    `${receiver?.name ?? 'Пользователь'} принял твою заявку в друзья`,
    { type: 'friend_accepted', friendUuid: record.receiver_id }
  )
}
