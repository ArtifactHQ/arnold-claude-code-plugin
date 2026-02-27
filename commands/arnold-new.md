---
name: arnold:new
description: Start a new product — describe your idea and Arnold will generate an initial spec for you to explore and refine.
args: "[idea] — optional product description (e.g., 'a dog walking app'). If omitted, you'll be asked."
---

# /arnold:new

Start the discovery flow for a new product.

## Steps

1. If the user provided an idea as an argument, use it directly. Otherwise, ask the user to describe what they want to build in a sentence or two.

2. Call `create_product` with the user's description.

3. Present the result conversationally:
   - **Personas:** Introduce each persona with a brief story of their experience, not just a label. "Your dog walker signs up, sets their neighborhood and hours, and starts seeing nearby requests."
   - **Domains:** Summarize the major areas Arnold identified — what the product is made of.
   - **Open questions:** Pick the one or two most interesting open questions Arnold surfaced and ask the user about them naturally.

4. Invite the user to explore. They can ask about any persona, capability, or domain. They can propose changes or explore hypotheticals. The conversation is open-ended — follow their curiosity.

## Behavior

- Do not ask for detailed requirements before calling `create_product`. Arnold generates the initial spec from a brief description and surfaces what needs clarification through `open_questions`.
- After presenting the initial overview, let the user drive. They might want to explore a persona, dig into a feature, ask "what if", or jump straight to building. Follow their lead.
- This command is a convenience entry point. Users can also just describe their idea in chat and the agent will call `create_product` — the command provides an explicit starting point for users who prefer it.
