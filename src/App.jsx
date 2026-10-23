import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from './assets/vite.svg'
import me from './assets/me.png'
import { Container, Row, Col } from "react-bootstrap";
import './App.css'
import 'bootstrap/dist/css/bootstrap.min.css';
import { AiFillGithub } from "react-icons/ai";
import { FaLinkedinIn } from "react-icons/fa";
import Typewriter from "typewriter-effect";
import Particles from "react-tsparticles";
import Particle from './Particle';
import dragon from './assets/dragon.png'; 
import Home from './components/home.jsx';
import Portfolio from './components/portfolio.jsx';
import {
  HashRouter as Router,
  Route,
  Routes,
  Navigate
} from "react-router-dom";

/*
  type writer effect
 about me section
*/
function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <Router basename={import.meta.env.BASE_URL}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/portfolio" element={<Portfolio />} />
          <Route path="*" element={<Navigate to="/"/>} />
        </Routes>
      </Router>
    </>
  )
}

export default App
