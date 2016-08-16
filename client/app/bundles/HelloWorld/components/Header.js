/*! React Starter Kit | MIT License | http://www.reactstarterkit.com/ */

import React from 'react';
import withScroll from '../../decorators/withViewportScroll';
// import NavMobile from '../NavMobile';
// import Logo from '../ui/Logo';

@withScroll
class Header extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let scrollTop = this.props.viewportScroll.top;
    if (scrollTop > 100 && scrollTop < 500) {
      if (this.props.viewportScroll.scrollDown) {
        var scrollHead = 'b-header__hideDown';
      }
      if (this.props.viewportScroll.scrollUp) {
        var scrollHead = 'b-header__hideUp';
      }
    }
    if (scrollTop > 500) {
      if (this.props.viewportScroll.scrollDown) {
        var scrollHead = 'b-header__ScrollDown';
      }
      if (this.props.viewportScroll.scrollUp) {
        var scrollHead = 'b-header__ScrollUp';
      }
    }

    return (
      <header className="header">
        <div className={`b-header__container ${scrollHead}`}>
          <div className="b-header">
            {/*<NavMobile className="b-header__nav-mobile"/>*/}
            {/*<Logo className="b-header__logo"/>*/}
  
            <div className="b-header__logo">
              <a className="Logo" href="/"></a>
            </div>
            
            <div className="b-header__nav" role="navigation">
              <div className="b-nav" role="navigation">
                <span className="b-nav__text">+7 495 742-1212</span>
                <a className="b-nav__link" href="/about">О компании</a>
                <a className="b-nav__link" href="/contact">Контакты</a>
                <a className="b-nav__help b-help" href="https://inna.ru/#/help" title="Помощь" target="_blank">
                  <i className="b-help__icon" title="Помощь" alt="Помощь"></i>
                </a>
              </div>
            </div>
          </div>
        </div>
      </header>
    );
  }

}

export default Header;
