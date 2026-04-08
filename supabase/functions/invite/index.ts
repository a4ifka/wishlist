import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const APP_SCHEME = 'wishlist'

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*' } })
  }

  const url = new URL(req.url)
  const roomId = url.searchParams.get('room')

  if (!roomId || isNaN(Number(roomId))) {
    return respond404()
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const { data: room } = await supabase
    .from('rooms')
    .select('id, name, is_public, event_date, owner')
    .eq('id', roomId)
    .eq('is_public', true)
    .single()

  if (!room) return respond404()

  const { data: ownerData } = await supabase
    .from('users_info')
    .select('name')
    .eq('uuid', room.owner)
    .single()

  const { data: wishes } = await supabase
    .from('wishes')
    .select('id, name, price, image_url, is_fulfilled')
    .eq('room_id', roomId)
    .order('is_fulfilled', { ascending: true })
    .order('id', { ascending: true })

  const ownerName: string = ownerData?.name ?? 'Пользователь'
  const deepLink = `${APP_SCHEME}://invite?room=${roomId}`

  let eventDate = ''
  if (room.event_date) {
    const d = new Date(room.event_date)
    eventDate = d.toLocaleDateString('ru-RU', { day: 'numeric', month: 'long', year: 'numeric' })
  }

  return new Response(
    renderHTML({ room, ownerName, eventDate, wishes: wishes ?? [], deepLink }),
    {
      status: 200,
      headers: {
        'content-type': 'text/html; charset=utf-8',
        'cache-control': 'public, max-age=60',
      },
    }
  )
})

// ─── Helpers ──────────────────────────────────────────────────────────────────

function respond404(): Response {
  return new Response(
    '<!DOCTYPE html><html lang="ru"><head><meta charset="UTF-8"></head>' +
    '<body style="font-family:sans-serif;text-align:center;padding:60px 20px;background:#f0eeff">' +
    '<div style="max-width:360px;margin:0 auto;background:#fff;border-radius:20px;padding:40px 24px">' +
    '<h2 style="color:#6D57FC;margin-bottom:8px">Вишлист не найден</h2>' +
    '<p style="color:#888;font-size:14px">Ссылка устарела или вишлист стал приватным.</p>' +
    '</div></body></html>',
    { status: 404, headers: { 'content-type': 'text/html; charset=utf-8' } }
  )
}

function escapeHtml(text: string): string {
  return String(text)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
}

// Форматирование цены без toLocaleString чтобы избежать неразрывных пробелов
function formatPrice(price: number): string {
  return Math.round(price).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ')
}

function wishCard(w: any): string {
  const img = w.image_url
    ? `<img src="${escapeHtml(w.image_url)}" alt="" class="wish-img" onerror="this.classList.add('wish-img-ph')">`
    : `<div class="wish-img wish-img-ph"></div>`
  const price = w.price
    ? `<p class="wish-price">${formatPrice(Number(w.price))} &#8381;</p>`
    : ''
  const badge = w.is_fulfilled ? `<span class="badge">Забронировано</span>` : ''
  return (
    `<div class="wish${w.is_fulfilled ? ' done' : ''}">` +
    img +
    `<div class="wish-info"><p class="wish-name">${escapeHtml(w.name)}</p>${price}${badge}</div>` +
    `</div>`
  )
}

function renderHTML({ room, ownerName, eventDate, wishes, deepLink }: {
  room: any
  ownerName: string
  eventDate: string
  wishes: any[]
  deepLink: string
}): string {
  const initial = (ownerName[0] ?? '?').toUpperCase()
  const wishesHtml = wishes.length
    ? wishes.map(wishCard).join('')
    : '<p class="empty">Вишлист пока пуст</p>'
  const dateLine = eventDate
    ? `<div class="date-chip">${escapeHtml(eventDate)}</div>`
    : ''

  return (
    `<!DOCTYPE html>` +
    `<html lang="ru">` +
    `<head>` +
    `<meta charset="UTF-8">` +
    `<meta name="viewport" content="width=device-width, initial-scale=1.0">` +
    `<title>${escapeHtml(ownerName)} &mdash; ${escapeHtml(room.name)}</title>` +
    `<style>` +
    `*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}` +
    `body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#f0eeff;padding:20px 16px 56px}` +
    `.container{max-width:480px;margin:0 auto}` +
    `.header{background:linear-gradient(135deg,#6D57FC 0%,#9B79F6 100%);border-radius:24px;padding:32px 24px;text-align:center;color:#fff;margin-bottom:14px}` +
    `.avatar{width:68px;height:68px;background:rgba(255,255,255,.22);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:30px;font-weight:700;margin:0 auto 14px}` +
    `.owner-sub{font-size:13px;opacity:.8;margin-bottom:6px}` +
    `.room-name{font-size:22px;font-weight:700;line-height:1.2;margin-bottom:12px}` +
    `.date-chip{display:inline-flex;align-items:center;gap:6px;background:rgba(255,255,255,.2);border-radius:20px;padding:6px 16px;font-size:13px}` +
    `.open-btn{display:block;background:#fff;color:#6D57FC;border-radius:16px;padding:16px;font-size:16px;font-weight:700;text-decoration:none;text-align:center;margin-bottom:20px;box-shadow:0 4px 20px rgba(109,87,252,.15)}` +
    `.section-title{font-size:16px;font-weight:700;color:#1a1a1a;margin-bottom:10px}` +
    `.wish{display:flex;align-items:center;gap:14px;background:#fff;border-radius:16px;padding:14px;margin-bottom:10px}` +
    `.wish.done{opacity:.45}` +
    `.wish-img{width:64px;height:64px;border-radius:12px;object-fit:cover;flex-shrink:0}` +
    `.wish-img-ph{background:#ede9ff}` +
    `.wish-info{flex:1;min-width:0}` +
    `.wish-name{font-size:14px;font-weight:600;color:#1a1a1a;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin-bottom:4px}` +
    `.wish-price{font-size:15px;font-weight:700;color:#6D57FC}` +
    `.badge{display:inline-block;margin-top:5px;background:#f0f0f0;border-radius:8px;padding:2px 9px;font-size:11px;color:#888}` +
    `.empty{text-align:center;color:#aaa;padding:32px 0;font-size:14px}` +
    `</style>` +
    `</head>` +
    `<body>` +
    `<div class="container">` +
    `<div class="header">` +
    `<div class="avatar">${initial}</div>` +
    `<p class="owner-sub">${escapeHtml(ownerName)} приглашает вас</p>` +
    `<h1 class="room-name">${escapeHtml(room.name)}</h1>` +
    dateLine +
    `</div>` +
    `<a class="open-btn" href="${deepLink}">Открыть в приложении &rarr;</a>` +
    `<p class="section-title">Вишлист</p>` +
    wishesHtml +
    `</div>` +
    `</body>` +
    `</html>`
  )
}
