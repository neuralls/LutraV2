# Lutra

**Lutra** is a framework including libraries that are designed to minimize redundancy and optimize the development environment. The core objective of this rewrite is to reduce code duplication and provide dynamically reusable components, improving efficiency, scalability, and optimization.

## Purpose

When Lutra was initially created, it became clear that there were significant gaps in the code, and a lot of components could be reused dynamically. The goal of this rewrite is to address these issues, ensuring that the framework is lean, flexible, and easy to integrate into various projects.

## Features

- **Reduced Redundancy**: Code has been streamlined to eliminate duplication and unnecessary complexity.
- **Dynamic Reusability**: Components are designed to be flexible and reusable across different environments.
- **Optimized for Performance**: Enhancements to make the framework more efficient, reducing overhead and improving execution speed.
- **Modular Design**: Use only the parts of the framework you need, without unnecessary dependencies.
- **Improved Documentation**: Clear and concise instructions to help developers integrate and use the framework.

## Usage
```lua
local owner, branch = "neuralls", "main"

function Import(file: string, args)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/LutraV2/%s/%s.lua"):format(owner, branch, file)), "Framework")(args or {})
end
```
<small>repo heavily inspired by [hydroxide](https://github.com/Upbolt/Hydroxide) </small>
