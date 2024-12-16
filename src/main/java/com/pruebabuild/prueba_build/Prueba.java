package com.pruebabuild.prueba_build;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Prueba {

    @GetMapping("/hola")
    public String index() {
        return "index";
    }
}
