{ lib
, buildPythonPackage
, fetchPypi
, nose
, jupyter-client
, ipython
, ipykernel
, prompt-toolkit
, pygments
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyter_console";
  version = "6.5.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z+aPHaFrw/b3jthG3VVD7AZ5Np+FBHNPEL/SBvquOeo=";
  };

  propagatedBuildInputs = [
    jupyter-client
    ipython
    ipykernel
    prompt-toolkit
    pygments
  ];
  nativeCheckInputs = [ nose ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "prompt_toolkit>=2.0.0,<2.1.0" "prompt_toolkit"
  '';

  # ValueError: underlying buffer has been detached
  doCheck = false;

  meta = {
    description = "Jupyter terminal console";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
  };
}
