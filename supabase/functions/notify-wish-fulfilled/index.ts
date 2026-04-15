Deno.serve(async (_req: Request) => {
  // Уведомление о бронировании отключено — это должно оставаться секретом для именинника
  return new Response('disabled', { status: 200 })
})
