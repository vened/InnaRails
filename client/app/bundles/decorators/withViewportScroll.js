/*! React Starter Kit | MIT License | http://www.reactstarterkit.com/ */

import React from 'react';
import EventEmitter from 'eventemitter3';
import {canUseDOM} from 'fbjs/lib/ExecutionEnvironment';
import _ from 'lodash'; // eslint-disable-line no-unused-vars

let EE;
let viewportScroll = {
    top       : 0,
    scrollDown: false,
    scrollUp  : false
};
const SCROLL_EVENT = 'scroll';

function handleWindowScroll() {
    // кроссбраузерное вычисление скролла
    var supportPageOffset = window.pageXOffset !== undefined;
    var isCSS1Compat = ((document.compatMode || "") === "CSS1Compat");
    //var x = supportPageOffset ? window.pageXOffset : isCSS1Compat ? document.documentElement.scrollLeft : document.body.scrollLeft;
    var y = supportPageOffset ? window.pageYOffset : isCSS1Compat ? document.documentElement.scrollTop : document.body.scrollTop;
    
    if (viewportScroll.top !== y) {
        viewportScroll = {
            top       : y,
            scrollDown: (viewportScroll.top < y) ? true : false,
            scrollUp  : (viewportScroll.top > y) ? true : false,
        };
        EE.emit(SCROLL_EVENT, viewportScroll);
    }
}

function withViewportScroll(ComposedComponent) {
    return class WithViewportScroll extends React.Component {
        
        constructor() {
            super();
            this.state = {
                viewportScroll: viewportScroll
            };
        }
        
        componentDidMount() {
            if (!EE) {
                EE = new EventEmitter();
                window.addEventListener('scroll', _.debounce(handleWindowScroll, 10));
                //window.addEventListener('scroll', handleWindowScroll);
            }
            EE.on(SCROLL_EVENT, this.handleResize, this);
        }
        
        componentWillUnmount() {
            EE.removeListener(SCROLL_EVENT, this.handleResize, this);
            if (!EE.listeners(SCROLL_EVENT, true)) {
                window.removeEventListener('scroll', handleWindowScroll);
                EE = null;
            }
        }
        
        render() {
            return <ComposedComponent {...this.props} viewportScroll={this.state.viewportScroll}/>;
        }
        
        handleResize(value) {
            this.setState({viewportScroll: value}); // eslint-disable-line react/no-set-state
        }
        
    };
}

export default withViewportScroll;
