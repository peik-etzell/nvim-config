{
  inputs = {
    src = {
      url = "./";
      flake = false;
    };
  };
  outputs =
    { src, ... }:
    {
      inherit src;
    };
}
