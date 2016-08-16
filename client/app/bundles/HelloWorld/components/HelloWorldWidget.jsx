// HelloWorldWidget is an arbitrary name for any "dumb" component. We do not recommend suffixing
// all your dump component names with Widget.

import React, {PropTypes} from 'react';
import _ from 'lodash';
import  {Modal} from 'travel-ui';
import withScroll from '../../decorators/withViewportScroll';



@withScroll
export default class HelloWorldWidget extends React.Component {
    static propTypes = {
        // If you have lots of data or action properties, you should consider grouping them by
        // passing two properties: "data" and "actions".
        updateName: PropTypes.func.isRequired,
        name      : PropTypes.string.isRequired,
    };
    
    constructor(props, context) {
        super(props, context);
        
        this.state = {
            showDialog     : false,
            showModalSmall : false,
            showModalMedium: false,
            showModalLarge : false,
        };
        // Uses lodash to bind all methods to the context of the object instance, otherwise
        // the methods defined here would not refer to the component's class, not the component
        // instance itself.
        _.bindAll(this, 'handleChange');
    }
    
    
    renderModalSmall() {
        this.setState({
            showModalSmall: !this.state.showModalSmall
        })
    }
    
    
    // React will automatically provide us with the event `e`
    handleChange(e) {
        const name = e.target.value;
        this.props.updateName(name);
    }
    
    render() {
        const {name} = this.props;
    
        let scrollTop = this.props.viewportScroll.top;
        return (
            <div className="container">
                <h3>
                    Hello, {name}! {scrollTop}
                </h3>
                <hr />
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <br/>
                Say hello to:
                <form className="form-horizontal">
                    <label>
                        Say hello to:
                    </label>
                    <input
                        type="text"
                        value={name}
                        onChange={this.handleChange}
                    />
                </form>
                <button onClick={this.renderModalSmall.bind(this)}>renderModalSmall</button>
                
                <Modal isShow={this.state.showModalSmall}
                       isOverlay={this.renderModalSmall.bind(this)}
                       small={true}>
                    child dialog
                    <br/>
                    child dialog
                    <br/>
                    child dialog
                    <br/>
                    child dialog
                    <br/>
                    child dialog
                    <br/>
                    child dialog
                    <br/>
                    child dialog
                    <br/>
                </Modal>
            </div>
        );
    }
}
