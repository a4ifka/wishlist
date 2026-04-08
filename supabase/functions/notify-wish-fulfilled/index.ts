import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { sendNotification } from '../_shared/fcm.ts'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req: Request) => {
  try {
    const payload = await req.json()

    // Webhook: type=UPDATE, table=wishes
    if (payload.type !== 'UPDATE') return new Response('skip', { status: 200 })

    const newRecord = payload.record
    const oldRecord = payload.old_record

    // Срабатываем только когда is_fulfilled меняется false → true
    if (!newRecord.is_fulfilled || oldRecord.is_fulfilled) {
      return new Response('skip', { status: 200 })
    }

    // Получаем комнату, чтобы найти владельца
    const { data: room } = await supabase
      .from('rooms')
      .select('owner')
      .eq('id', newRecord.room_id)
      .single()

    if (!room) return new Response('no room', { status: 200 })

    // FCM-токен владельца
    const { data: owner } = await supabase
      .from('users_info')
      .select('fcm_token, name')
      .eq('uuid', room.owner)
      .single()

    if (!owner?.fcm_token) return new Response('no token', { status: 200 })

    // Имя того, кто забронировал
    let bookerName = 'Друг'
    if (newRecord.fulfilled_by) {
      const { data: booker } = await supabase
        .from('users_info')
        .select('name')
        .eq('uuid', newRecord.fulfilled_by)
        .single()
      if (booker?.name) bookerName = booker.name
    }

    await sendNotification(
      owner.fcm_token,
      '🎁 Кто-то хочет подарить тебе подарок!',
      `${bookerName} собирается подарить тебе «${newRecord.name}»`,
      { type: 'wish_fulfilled', wishId: String(newRecord.id) }
    )

    return new Response('ok', { status: 200 })
  } catch (e) {
    console.error(e)
    return new Response('error', { status: 500 })
  }
})
