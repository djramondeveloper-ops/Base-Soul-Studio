export async function fetchNui(eventName, data) {
  try {
    const resp = await fetch(`https://interact/${eventName}`, {
      method: "post",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: JSON.stringify(data),
    });

    return await resp.json();
  } catch (error) {
    console.log(`fetching NUI event: ${eventName}`, data);
  }
}
