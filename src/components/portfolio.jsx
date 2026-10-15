import { useState } from 'react'
import reactLogo from '../assets/react.svg'
import viteLogo from '../assets/vite.svg'
import me from '../assets/me.png'
import piano from '../assets/piano.png'
import weather from '../assets/weather.png'
import game from '../assets/game.png'
import { Container, Row, Col } from "react-bootstrap";
import '../App.css'
import 'bootstrap/dist/css/bootstrap.min.css';
import { AiFillGithub } from "react-icons/ai";
import { FaLinkedinIn } from "react-icons/fa";
import Typewriter from "typewriter-effect";
import Particles from "react-tsparticles";
import Particle from '../Particle';
import dragon from '../assets/dragon.png'; 

/*
  type writer effect
 about me section
*/
function Portfolio() {
  const [count, setCount] = useState(0)

  return (
    <>
      <section id="center" className="dark-mode">
        <Particle />
        <Container>
          <Row style={{ paddingBottom: 75 }}>
            <Col md={12}>
              <div style={{ paddingTop: 50 }}>
                <h2>My Portfolio</h2>
              </div>
            </Col>
          </Row>
          <Row style={{ paddingBottom: 75 }}>
            <Col md={6}>
                  <img
                    src={weather}
                    style={{ maxHeight: "450px", index: 1201 }}
                    className="responsive-img"
              />
            </Col>
            <Col md={6} className="portfolio-text">
                <div>Weather app built in React Native</div>            
            </Col>
          </Row>
          <Row style={{ paddingBottom: 75 }}>
            <Col md={6}>
                  <img
                    src={piano}
                    style={{ maxHeight: "450px", index: 1201 }}
                    className="responsive-img"
              />
            </Col>
            <Col md={6} className="portfolio-text">
                <div>Recreating the piano on an app from scratch</div>            
            </Col>
          </Row>
            <Row style={{ paddingBottom: 75 }}>
              <Col md={6}>
                  <img
                    src={game}
                    style={{ maxHeight: "450px", index: 1201 }}
                    className="responsive-img"
                />
              </Col>
              <Col md={6} className="portfolio-text">
                <div>A bubble shooting game coded in Pico8 console</div>            
              </Col>
          </Row>
        </Container>
      </section>
    </>
  )
}

export default Portfolio
