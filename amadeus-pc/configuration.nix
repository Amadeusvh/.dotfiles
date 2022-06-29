{ pkgs, ... }:
{
  networking = {
    hostId = "cc1f83cb";
    hostName = "amadeus-pc";
  };
  services.minidlna.friendlyName = "amadeus-pc";
}
