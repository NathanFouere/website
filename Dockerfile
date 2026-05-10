FROM nixos/nix AS build

WORKDIR /app

COPY flake.nix flake.lock ./

COPY src/ ./src/

RUN nix build . -o /app/public --extra-experimental-features "nix-command flakes"

COPY . .

FROM nginx:1.29-alpine

WORKDIR /usr/share/nginx/html

COPY --from=build /app/public .

# Expose port 80
EXPOSE 80/tcp