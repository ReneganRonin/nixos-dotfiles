self: super: 
{
  julia = super.julia.overrideAttrs (old: rec { 
    majorVersion = "1";
    minorVersion = "6";
    maintenanceVersion = "0";
    version = "${majorVersion}.${minorVersion}.${maintenanceVersion}";
    src_sha256= "sha256-Rs09TKSgQThHVK6YAk2b+tjx5z7jR2tEMCx5cTdoEJM=";
    src = super.fetchzip {
       url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
       sha256 = src_sha256;
    };

 });
}
