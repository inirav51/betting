import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import web3 from './web3';
import betting from './betting';

class App extends Component {
	state = {
		dealer: '',
		
	};
	
	async componentDidMount() {
		const dealer = await betting.methods.dealer().call();
		
		this.setState ({ dealer });
	}
  render() {
    return (
      <div>
		<h2> Betting Contract</h2>
		<p>This Contract is managed by {this.state.dealer} </p>
		</div>
    );
  }
}

export default App;
